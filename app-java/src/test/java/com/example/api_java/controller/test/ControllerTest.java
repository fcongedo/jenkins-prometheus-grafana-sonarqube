package com.example.api_java.controller.test;

import com.example.api_java.models.Persona;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;
import com.example.api_java.repository.Repository;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@SpringBootTest
@AutoConfigureMockMvc
public class ControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @Autowired
    private Repository repo;

    @BeforeEach
    void setUp() {
        // Limpiar la base de datos antes de cada prueba
        repo.deleteAll();
    }

    @Test
    void testIndex() throws Exception {
        mockMvc.perform(get("/"))
                .andExpect(status().isOk())
                .andExpect(content().string("CONECTADO"));
    }

    @Test
    void testGetPersonas() throws Exception {
        // Primero, agregamos una persona a la base de datos
        Persona persona = new Persona();
        persona.setNombre("Juan Pérez");
        persona.setTelefono("123456789");
        repo.save(persona);

        // Realizamos la solicitud GET para obtener todas las personas
        mockMvc.perform(get("/personas"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$[0].nombre").value("Juan Pérez"))
                .andExpect(jsonPath("$[0].telefono").value("123456789"));
    }

    @Test
    void testCreatePersona() throws Exception {
        // Creamos una persona a través del endpoint POST
        String personaJson = "{\"nombre\":\"Ana López\", \"telefono\":\"987654321\"}";

        mockMvc.perform(post("/create")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(personaJson))
                .andExpect(status().isOk())
                .andExpect(content().string("Creado"));

        // Verificamos si la persona fue creada en la base de datos
        mockMvc.perform(get("/personas"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$[0].nombre").value("Ana López"));
    }

    @Test
    void testUpdatePersona() throws Exception {
        // Primero, agregamos una persona a la base de datos
        Persona persona = new Persona();
        persona.setNombre("Carlos García");
        persona.setTelefono("555555555");
        repo.save(persona);

        // Ahora actualizamos los datos de esa persona
        String updatedPersonaJson = "{\"nombre\":\"Carlos García\", \"telefono\":\"111111111\"}";

        mockMvc.perform(put("/update/" + persona.getId())
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(updatedPersonaJson))
                .andExpect(status().isOk())
                .andExpect(content().string("Modificado correctamente"));

        // Verificamos si el teléfono fue actualizado
        mockMvc.perform(get("/personas"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$[0].telefono").value("111111111"));
    }

    @Test
    void testDeletePersona() throws Exception {
        // Primero, agregamos una persona a la base de datos
        Persona persona = new Persona();
        persona.setNombre("Pedro Sánchez");
        persona.setTelefono("222222222");
        repo.save(persona);

        // Ahora, eliminamos esa persona
        mockMvc.perform(delete("/delete/" + persona.getId()))
                .andExpect(status().isOk())
                .andExpect(content().string("Eliminado"));

        // Verificamos si la persona fue eliminada
        mockMvc.perform(get("/personas"))
                .andExpect(status().isOk())
                .andExpect(content().string("[]"));
    }
}
