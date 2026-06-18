package pe.restaurant.activos.support;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;
import org.springframework.data.web.PageableHandlerMethodArgumentResolver;
import org.springframework.http.converter.json.MappingJackson2HttpMessageConverter;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;

/**
 * MockMvc en {@code standaloneSetup} no incluye por defecto el convertidor JSON;
 * sin él las respuestas {@code ApiResponse} se serializan como texto y fallan los {@code jsonPath}.
 */
public final class ControllerMockMvcFactory {

    private static final ObjectMapper OBJECT_MAPPER = createObjectMapper();

    private ControllerMockMvcFactory() {
    }

    private static ObjectMapper createObjectMapper() {
        ObjectMapper mapper = new ObjectMapper();
        mapper.registerModule(new JavaTimeModule());
        mapper.disable(SerializationFeature.WRITE_DATES_AS_TIMESTAMPS);
        return mapper;
    }

    public static ObjectMapper objectMapper() {
        return OBJECT_MAPPER;
    }

    public static MockMvc standalone(Object controller) {
        return standalone(controller, false);
    }

    public static MockMvc standalone(Object controller, boolean pageableResolver) {
        var builder = MockMvcBuilders.standaloneSetup(controller)
                .setMessageConverters(new MappingJackson2HttpMessageConverter(OBJECT_MAPPER));
        if (pageableResolver) {
            builder.setCustomArgumentResolvers(new PageableHandlerMethodArgumentResolver());
        }
        return builder.build();
    }
}
