package com.example.api_java.controller;

import com.example.api_java.models.Persona;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import com.example.api_java.repository.Repository;

import java.util.List;

@RestController
public class Controller {

    @Autowired
    private Repository repo;

    @GetMapping()
    public String index(){
        return "CONECTADO";
    }

    @GetMapping("/personas")
    public List<Persona> getPersonas() {
        return repo.findAll();
    }

    @PostMapping("/create")
    public String save(@RequestBody Persona persona) {
        repo.save(persona);
        return "Creado";
    }

    @PutMapping("/update/{id}")
    public String update(@PathVariable Long id, @RequestBody Persona persona) {
        Persona updatePersona = repo.findById(id).get();
        updatePersona.setNombre(persona.getNombre());
        updatePersona.setTelefono(persona.getTelefono());
        repo.save(updatePersona);
        return "Modificado correctamente";
    }

    @DeleteMapping("/delete/{id}")
    public String delete(@PathVariable Long id) {
        Persona deletePersona = repo.findById(id).get();
        repo.delete(deletePersona);
        return "Eliminado";
    }

}
