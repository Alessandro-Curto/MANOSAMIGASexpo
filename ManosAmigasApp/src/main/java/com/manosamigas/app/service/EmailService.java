package com.manosamigas.app.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Service;

@Service
public class EmailService {

    @Autowired
    private JavaMailSender mailSender;

    public void enviarCorreo(String destinatario, String asunto, String cuerpo) {
        SimpleMailMessage mensaje = new SimpleMailMessage();
        mensaje.setTo(destinatario);
        mensaje.setSubject(asunto);
        mensaje.setText(cuerpo);

        try {
            mailSender.send(mensaje);
            System.out.println("Correo enviado a " + destinatario);
        } catch (Exception e) {
            System.err.println("Error enviando correo: " + e.getMessage());
            throw e;
        }
    }
}

