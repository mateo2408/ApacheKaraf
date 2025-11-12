package org.example.message.impl;

import org.example.message.api.MessageService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

/**
 * Implementación del servicio de procesamiento de mensajes.
 * Este servicio puede ser iniciado y detenido de forma independiente.
 */
public class MessageServiceImpl implements MessageService {

    private static final Logger logger = LoggerFactory.getLogger(MessageServiceImpl.class);
    private final DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");

    @Override
    public String processMessage(String message) {
        String timestamp = LocalDateTime.now().format(formatter);
        String processed = String.format("[%s] Procesado: %s", timestamp, message.toUpperCase());
        logger.info("Mensaje procesado: {}", processed);
        return processed;
    }

    @Override
    public String getServiceName() {
        return "Message Service Implementation v1.0";
    }
}

