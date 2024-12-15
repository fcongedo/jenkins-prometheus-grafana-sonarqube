package com.example.api_java.repository;

import com.example.api_java.models.Persona;
import org.springframework.data.jpa.repository.JpaRepository;

public interface Repository extends JpaRepository <Persona, Long> {

}


