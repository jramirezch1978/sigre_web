package pe.restaurant.finanzas.validation;

import jakarta.validation.ConstraintValidator;
import jakarta.validation.ConstraintValidatorContext;
import java.lang.reflect.Field;

public class AtLeastOneNotNullValidator implements ConstraintValidator<AtLeastOneNotNull, Object> {

    private String[] fieldNames;

    @Override
    public void initialize(AtLeastOneNotNull constraintAnnotation) {
        this.fieldNames = constraintAnnotation.fieldNames();
    }

    @Override
    public boolean isValid(Object object, ConstraintValidatorContext constraintValidatorContext) {
        if (object == null) {
            return true;
        }

        try {
            for (String fieldName : fieldNames) {
                Field field = object.getClass().getDeclaredField(fieldName);
                field.setAccessible(true);
                Object value = field.get(object);
                
                if (value != null) {
                    return true;
                }
            }
            return false;
        } catch (Exception e) {
            return false;
        }
    }
}
