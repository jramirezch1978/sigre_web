package com.sigre.common.maestro;

import jakarta.persistence.Column;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import jakarta.persistence.UniqueConstraint;

import java.lang.reflect.Field;
import java.lang.reflect.Modifier;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Optional;
import java.util.concurrent.ConcurrentHashMap;

/**
 * Cadena de descubrimiento del unique key de negocio más próximo al PK:
 * <ol>
 *   <li>{@link BusinessUniqueKey} en campo</li>
 *   <li>{@code @Column(unique = true)} no-PK, en orden de declaración</li>
 *   <li>primer atributo de negocio del primer {@link UniqueConstraint}</li>
 *   <li>convención de nombres ({@code codigo}, {@code tipoMov}, …)</li>
 * </ol>
 */
public final class DefaultBusinessUniqueKeyResolver implements BusinessUniqueKeyResolver {

    private static final List<String> CONVENTION_PROPERTIES = List.of(
            "codigo", "tipoMov", "cencos", "nroLote", "username", "email", "servicio");

    private final Map<Class<?>, Optional<String>> cache = new ConcurrentHashMap<>();

    @Override
    public Optional<String> resolveProperty(Class<?> entityClass) {
        if (entityClass == null || entityClass.isAnnotationPresent(NoBusinessUniqueKeySort.class)) {
            return Optional.empty();
        }
        return cache.computeIfAbsent(entityClass, this::resolveUncached);
    }

    private Optional<String> resolveUncached(Class<?> entityClass) {
        List<Field> fields = persistentFields(entityClass);

        Optional<String> annotated = fields.stream()
                .filter(f -> f.isAnnotationPresent(BusinessUniqueKey.class))
                .map(Field::getName)
                .findFirst();
        if (annotated.isPresent()) {
            return annotated;
        }

        Optional<String> uniqueColumn = fields.stream()
                .filter(f -> !f.isAnnotationPresent(Id.class))
                .filter(f -> {
                    Column column = f.getAnnotation(Column.class);
                    return column != null && column.unique();
                })
                .map(Field::getName)
                .findFirst();
        if (uniqueColumn.isPresent()) {
            return uniqueColumn;
        }

        Optional<String> fromConstraint = resolveFromUniqueConstraints(entityClass, fields);
        if (fromConstraint.isPresent()) {
            return fromConstraint;
        }

        Map<String, Field> byName = new LinkedHashMap<>();
        for (Field field : fields) {
            byName.put(field.getName(), field);
        }
        for (String candidate : CONVENTION_PROPERTIES) {
            if (byName.containsKey(candidate) && !byName.get(candidate).isAnnotationPresent(Id.class)) {
                return Optional.of(candidate);
            }
        }
        return Optional.empty();
    }

    private Optional<String> resolveFromUniqueConstraints(Class<?> entityClass, List<Field> fields) {
        Table table = entityClass.getAnnotation(Table.class);
        if (table == null || table.uniqueConstraints().length == 0) {
            return Optional.empty();
        }

        Map<String, Field> byColumn = new LinkedHashMap<>();
        for (Field field : fields) {
            byColumn.put(columnName(field), field);
        }

        for (UniqueConstraint constraint : table.uniqueConstraints()) {
            for (String column : constraint.columnNames()) {
                Field field = byColumn.get(normalize(column));
                if (field == null || field.isAnnotationPresent(Id.class) || isForeignKeyLike(field)) {
                    continue;
                }
                return Optional.of(field.getName());
            }
        }
        return Optional.empty();
    }

    private static boolean isForeignKeyLike(Field field) {
        String name = field.getName();
        return name.endsWith("Id") || name.equals("id");
    }

    private static String columnName(Field field) {
        Column column = field.getAnnotation(Column.class);
        if (column != null && !column.name().isBlank()) {
            return normalize(column.name());
        }
        return normalize(toSnakeCase(field.getName()));
    }

    private static String normalize(String value) {
        return value == null ? "" : value.trim().toLowerCase(Locale.ROOT);
    }

    private static String toSnakeCase(String camel) {
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < camel.length(); i++) {
            char c = camel.charAt(i);
            if (Character.isUpperCase(c) && i > 0) {
                sb.append('_');
            }
            sb.append(Character.toLowerCase(c));
        }
        return sb.toString();
    }

    private static List<Field> persistentFields(Class<?> entityClass) {
        List<Field> fields = new ArrayList<>();
        Class<?> current = entityClass;
        while (current != null && current != Object.class) {
            for (Field field : current.getDeclaredFields()) {
                if (Modifier.isStatic(field.getModifiers()) || field.isSynthetic()) {
                    continue;
                }
                fields.add(field);
            }
            current = current.getSuperclass();
        }
        return fields;
    }
}
