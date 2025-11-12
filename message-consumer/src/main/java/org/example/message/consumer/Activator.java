package org.example.message.consumer;

import org.example.message.api.MessageService;
import org.osgi.framework.BundleActivator;
import org.osgi.framework.BundleContext;
import org.osgi.framework.ServiceReference;
import org.osgi.util.tracker.ServiceTracker;
import org.osgi.util.tracker.ServiceTrackerCustomizer;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.Timer;
import java.util.TimerTask;

/**
 * Activador del bundle consumidor de mensajes.
 * Este bundle demuestra el bajo acoplamiento usando ServiceTracker.
 * Puede funcionar sin el servicio y adaptarse cuando este aparece/desaparece.
 */
public class Activator implements BundleActivator {

    private static final Logger logger = LoggerFactory.getLogger(Activator.class);
    private ServiceTracker<MessageService, MessageService> serviceTracker;
    private Timer timer;
    private int messageCounter = 0;

    @Override
    public void start(BundleContext context) throws Exception {
        logger.info("*************************************************");
        logger.info("Iniciando Message Consumer Bundle...");
        logger.info("*************************************************");

        // Crear un ServiceTracker para rastrear el servicio MessageService
        serviceTracker = new ServiceTracker<>(
            context,
            MessageService.class,
            new MessageServiceTrackerCustomizer(context)
        );
        serviceTracker.open();

        // Iniciar un timer que envía mensajes periódicamente
        timer = new Timer("MessageConsumer-Timer", true);
        timer.scheduleAtFixedRate(new TimerTask() {
            @Override
            public void run() {
                sendMessage();
            }
        }, 2000, 5000); // Primer mensaje después de 2s, luego cada 5s

        logger.info("Message Consumer iniciado - enviando mensajes cada 5 segundos");
        logger.info("*************************************************");
    }

    @Override
    public void stop(BundleContext context) throws Exception {
        logger.info("*************************************************");
        logger.info("Deteniendo Message Consumer Bundle...");
        logger.info("*************************************************");

        // Detener el timer
        if (timer != null) {
            timer.cancel();
            logger.info("Timer de mensajes detenido");
        }

        // Cerrar el service tracker
        if (serviceTracker != null) {
            serviceTracker.close();
            logger.info("Service tracker cerrado");
        }

        logger.info("*************************************************");
    }

    private void sendMessage() {
        messageCounter++;
        String message = String.format("Mensaje #%d desde Consumer", messageCounter);

        // Obtener el servicio del tracker
        MessageService service = serviceTracker.getService();

        if (service != null) {
            try {
                String result = service.processMessage(message);
                logger.info("✓ Respuesta recibida: {}", result);
            } catch (Exception e) {
                logger.error("✗ Error al procesar mensaje: {}", e.getMessage());
            }
        } else {
            logger.warn("✗ MessageService no disponible - mensaje no enviado: {}", message);
            logger.warn("  (El bundle puede funcionar sin el servicio - bajo acoplamiento)");
        }
    }

    /**
     * Customizer para el ServiceTracker que nos notifica cuando
     * el servicio aparece o desaparece.
     */
    private class MessageServiceTrackerCustomizer
            implements ServiceTrackerCustomizer<MessageService, MessageService> {

        private final BundleContext context;

        public MessageServiceTrackerCustomizer(BundleContext context) {
            this.context = context;
        }

        @Override
        public MessageService addingService(ServiceReference<MessageService> reference) {
            MessageService service = context.getService(reference);
            logger.info(">>> MessageService DETECTADO: {}", service.getServiceName());
            logger.info("    El consumer ahora puede procesar mensajes");
            return service;
        }

        @Override
        public void modifiedService(ServiceReference<MessageService> reference,
                                   MessageService service) {
            logger.info(">>> MessageService MODIFICADO");
        }

        @Override
        public void removedService(ServiceReference<MessageService> reference,
                                  MessageService service) {
            logger.warn(">>> MessageService ELIMINADO/DETENIDO");
            logger.warn("    El consumer continuará funcionando pero sin procesar mensajes");
            context.ungetService(reference);
        }
    }
}

