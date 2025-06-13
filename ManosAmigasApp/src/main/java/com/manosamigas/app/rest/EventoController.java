// Ruta: src/main/java/com/manosamigas/app/rest/EventoController.java

package com.manosamigas.app.rest;

import com.manosamigas.app.dto.EventoDto;
import com.manosamigas.app.service.EventoService;
import org.springframework.dao.DuplicateKeyException; // <-- IMPORTACIÓN AÑADIDA
import org.springframework.http.HttpStatus; // <-- IMPORTACIÓN AÑADIDA
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@RestController
@RequestMapping("/api/eventos")
public class EventoController {
    private final EventoService eventoService;
    public EventoController(EventoService eventoService) { this.eventoService = eventoService; }

    @PostMapping
    public ResponseEntity<EventoDto> crearEvento(@RequestBody EventoDto eventoDto) {
        // --- INICIO DEL CAMBIO ---
        EventoDto eventoCreado = eventoService.crearEvento(eventoDto);
        // Se cambia OK (200) por CREATED (201) que es el estándar para creación de recursos.
        return new ResponseEntity<>(eventoCreado, HttpStatus.CREATED);
        // --- FIN DEL CAMBIO ---
    }

    @GetMapping
    public ResponseEntity<List<EventoDto>> listarEventos() {
        return ResponseEntity.ok(eventoService.listarTodos());
    }

    // --- INICIO DEL CÓDIGO AÑADIDO: MANEJADOR DE EXCEPCIONES ---
    /**
     * Manejador de excepciones para capturar intentos de crear registros duplicados.
     * @param e La excepción lanzada por el servicio.
     * @return Una respuesta HTTP 409 Conflict con un mensaje de error.
     */
    @ExceptionHandler(DuplicateKeyException.class)
    public ResponseEntity<String> handleDuplicateKeyException(DuplicateKeyException e) {
        return new ResponseEntity<>(e.getMessage(), HttpStatus.CONFLICT);
    }
    // --- FIN DEL CÓDIGO AÑADIDO ---
}