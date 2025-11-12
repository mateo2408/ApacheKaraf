package org.example.message.api;

/**
 * Interfaz de servicio para procesar mensajes.
 * Esta interfaz define el contrato del servicio OSGi.
 */
public interface MessageService {

    /**
     * Procesa un mensaje y retorna el resultado.
     *
     * @param message el mensaje a procesar
     * @return el mensaje procesado
     */
    String processMessage(String message);

    /**
     * Obtiene el nombre del procesador.
     *
     * @return el nombre del servicio
     */
    String getServiceName();
}

