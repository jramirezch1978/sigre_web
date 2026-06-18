package pe.restaurant.activos.config;

import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.web.cors.CorsConfigurationSource;

import java.lang.reflect.Modifier;

import static org.assertj.core.api.Assertions.assertThat;

@ExtendWith(MockitoExtension.class)
class ActivosSecurityConfigTest {

    @Mock
    private ActivosJwtAuthenticationFilter jwtAuthenticationFilter;
    @Mock
    private CorsConfigurationSource corsConfigurationSource;
    @InjectMocks
    private ActivosSecurityConfig securityConfig;

    @Nested
    class ClassAnnotations {

        @Test
        void classHasConfigurationAnnotation() {
            assertThat(ActivosSecurityConfig.class
                    .isAnnotationPresent(org.springframework.context.annotation.Configuration.class))
                    .isTrue();
        }

        @Test
        void classHasEnableWebSecurityAnnotation() {
            assertThat(ActivosSecurityConfig.class
                    .isAnnotationPresent(org.springframework.security.config.annotation.web.configuration.EnableWebSecurity.class))
                    .isTrue();
        }
    }

    @Nested
    class SecurityFilterChainMethod {

        @Test
        void methodExists() throws NoSuchMethodException {
            var method = ActivosSecurityConfig.class.getMethod("securityFilterChain", HttpSecurity.class);
            assertThat(method).isNotNull();
        }

        @Test
        void methodHasBeanAnnotation() throws NoSuchMethodException {
            var method = ActivosSecurityConfig.class.getMethod("securityFilterChain", HttpSecurity.class);
            assertThat(method.isAnnotationPresent(org.springframework.context.annotation.Bean.class)).isTrue();
        }

        @Test
        void methodReturnsSecurityFilterChain() throws NoSuchMethodException {
            var method = ActivosSecurityConfig.class.getMethod("securityFilterChain", HttpSecurity.class);
            assertThat(method.getReturnType()).isEqualTo(SecurityFilterChain.class);
        }

        @Test
        void methodIsPublic() throws NoSuchMethodException {
            var method = ActivosSecurityConfig.class.getMethod("securityFilterChain", HttpSecurity.class);
            assertThat(Modifier.isPublic(method.getModifiers())).isTrue();
        }

        @Test
        void methodDeclaresException() throws NoSuchMethodException {
            var method = ActivosSecurityConfig.class.getMethod("securityFilterChain", HttpSecurity.class);
            assertThat(method.getExceptionTypes()).contains(Exception.class);
        }

        @Test
        void methodAcceptsHttpSecurity() throws NoSuchMethodException {
            var method = ActivosSecurityConfig.class.getMethod("securityFilterChain", HttpSecurity.class);
            assertThat(method.getParameterCount()).isEqualTo(1);
            assertThat(method.getParameterTypes()[0]).isEqualTo(HttpSecurity.class);
        }
    }

    @Nested
    class Dependencies {

        @Test
        void instanceIsCreatedWithDependencies() {
            assertThat(securityConfig).isNotNull();
        }

        @Test
        void hasJwtFilterDependency() {
            var fields = ActivosSecurityConfig.class.getDeclaredFields();
            boolean hasJwtFilter = java.util.Arrays.stream(fields)
                    .anyMatch(f -> f.getType().equals(ActivosJwtAuthenticationFilter.class));
            assertThat(hasJwtFilter).isTrue();
        }

        @Test
        void hasCorsConfigSourceDependency() {
            var fields = ActivosSecurityConfig.class.getDeclaredFields();
            boolean hasCors = java.util.Arrays.stream(fields)
                    .anyMatch(f -> f.getType().equals(CorsConfigurationSource.class));
            assertThat(hasCors).isTrue();
        }

        @Test
        void classIsFinalOrHasExactlyTwoFields() {
            var fields = ActivosSecurityConfig.class.getDeclaredFields();
            long instanceFields = java.util.Arrays.stream(fields)
                    .filter(f -> !Modifier.isStatic(f.getModifiers()))
                    .count();
            assertThat(instanceFields).isEqualTo(2);
        }
    }

    @Nested
    class ConstructorValidation {

        @Test
        void hasRequiredArgsConstructor() {
            var constructors = ActivosSecurityConfig.class.getDeclaredConstructors();
            boolean hasTwo = java.util.Arrays.stream(constructors)
                    .anyMatch(c -> c.getParameterCount() == 2);
            assertThat(hasTwo).isTrue();
        }

        @Test
        void constructorParameterTypes() {
            var constructors = ActivosSecurityConfig.class.getDeclaredConstructors();
            var twoArgCtor = java.util.Arrays.stream(constructors)
                    .filter(c -> c.getParameterCount() == 2)
                    .findFirst()
                    .orElseThrow();
            var paramTypes = twoArgCtor.getParameterTypes();
            assertThat(paramTypes).containsExactlyInAnyOrder(
                    ActivosJwtAuthenticationFilter.class,
                    CorsConfigurationSource.class
            );
        }
    }
}
