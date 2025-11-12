package org.example.message.impl;

import org.example.message.api.MessageService;
import org.osgi.framework.BundleActivator;
import org.osgi.framework.BundleContext;
import org.osgi.framework.ServiceRegistration;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.Dictionary;
import java.util.Hashtable;

/**
 * Activador del bundle de servicio de mensajes.
 * Registra y desregistra el servicio cuando el bundle se inicia/detiene.
 */
public class Activator implements BundleActivator {

    private static final Logger logger = LoggerFactory.getLogger(Activator.class);
    private ServiceRegistration<MessageService> serviceRegistration;

    @Override
    public void start(BundleContext context) throws Exception {
        logger.info("=================================================");
        logger.info("Iniciando Message Service Bundle...");
        logger.info("=================================================");

        // Crear instancia del servicio
        MessageService messageService = new MessageServiceImpl();

        // Propiedades del servicio
        Dictionary<String, Object> properties = new Hashtable<>();
        properties.put("service.description", "Servicio de procesamiento de mensajes");
        properties.put("version", "1.0");

        // Registrar el servicio en el registro OSGi
        serviceRegistration = context.registerService(
            MessageService.class,
            messageService,
            properties
        );

        logger.info("Message Service registrado exitosamente!");
        logger.info("Nombre del servicio: {}", messageService.getServiceName());
        logger.info("=================================================");
    }

    @Override
    public void stop(BundleContext context) throws Exception {
        logger.info("=================================================");
        logger.info("Deteniendo Message Service Bundle...");
        logger.info("=================================================");

        // Desregistrar el servicio
        if (serviceRegistration != null) {
            serviceRegistration.unregister();
            logger.info("Message Service desregistrado exitosamente!");
        }

        logger.info("=================================================");
    }
}

