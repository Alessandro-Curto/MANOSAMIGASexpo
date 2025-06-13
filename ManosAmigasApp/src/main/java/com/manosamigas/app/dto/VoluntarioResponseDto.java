package com.manosamigas.app.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class VoluntarioResponseDto {
    private Long id;
    private String nombre;
    private String email;
    private String telefono;
}