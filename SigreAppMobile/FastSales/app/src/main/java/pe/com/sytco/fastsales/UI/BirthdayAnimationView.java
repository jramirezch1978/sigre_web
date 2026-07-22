package pe.com.sytco.fastsales.UI;

import android.content.Context;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Paint;
import android.util.AttributeSet;
import android.view.View;

import java.util.ArrayList;
import java.util.List;
import java.util.Random;

/**
 * Vista personalizada para animar confetti y fuegos artificiales
 * para el cumpleaños de un trabajador
 */
public class BirthdayAnimationView extends View implements Runnable {
    
    private List<Particle> particles;
    private Paint paint;
    private Random random;
    private boolean isAnimating = false;
    private Thread animationThread;
    
    // Colores vibrantes para confetti
    private int[] confettiColors = {
        Color.rgb(255, 0, 0),      // Rojo
        Color.rgb(0, 255, 0),      // Verde
        Color.rgb(0, 0, 255),      // Azul
        Color.rgb(255, 255, 0),    // Amarillo
        Color.rgb(255, 0, 255),    // Magenta
        Color.rgb(0, 255, 255),    // Cian
        Color.rgb(255, 165, 0),    // Naranja
        Color.rgb(255, 192, 203),  // Rosa
        Color.rgb(128, 0, 128),    // Púrpura
        Color.rgb(255, 215, 0)     // Dorado
    };
    
    public BirthdayAnimationView(Context context) {
        super(context);
        init();
    }
    
    public BirthdayAnimationView(Context context, AttributeSet attrs) {
        super(context, attrs);
        init();
    }
    
    public BirthdayAnimationView(Context context, AttributeSet attrs, int defStyleAttr) {
        super(context, attrs, defStyleAttr);
        init();
    }
    
    private void init() {
        particles = new ArrayList<>();
        paint = new Paint();
        paint.setAntiAlias(true);
        random = new Random();
    }
    
    /**
     * Inicia la animación
     */
    public void startAnimation() {
        if (isAnimating) {
            return;
        }
        
        // Esperar a que la vista tenga dimensiones válidas antes de iniciar
        post(new Runnable() {
            @Override
            public void run() {
                if (getWidth() > 0 && getHeight() > 0) {
                    isAnimating = true;
                    synchronized (particles) {
                        particles.clear();
                    }
                    
                    // Generar confetti inicial
                    addConfetti(50);
                    
                    // Iniciar hilo de animación
                    animationThread = new Thread(BirthdayAnimationView.this);
                    animationThread.start();
                }
            }
        });
    }
    
    /**
     * Detiene la animación
     */
    public void stopAnimation() {
        isAnimating = false;
        if (animationThread != null) {
            try {
                animationThread.interrupt();
                animationThread = null;
            } catch (Exception e) {
                // Ignorar
            }
        }
    }
    
    /**
     * Añade partículas de confetti
     */
    private void addConfetti(int count) {
        // Asegurarse de que la vista tiene dimensiones
        int width = getWidth();
        if (width <= 0) {
            return; // La vista aún no está lista
        }
        
        synchronized (particles) {
            for (int i = 0; i < count; i++) {
                float x = random.nextInt(width);
                float y = -random.nextInt(100); // Empiezan arriba de la pantalla
                
                Particle particle = new Particle();
                particle.x = x;
                particle.y = y;
                particle.vx = (random.nextFloat() - 0.5f) * 4f;
                particle.vy = random.nextFloat() * 5f + 3f;
                particle.rotation = random.nextFloat() * 360f;
                particle.rotationSpeed = (random.nextFloat() - 0.5f) * 10f;
                particle.size = random.nextFloat() * 10f + 5f;
                particle.color = confettiColors[random.nextInt(confettiColors.length)];
                particle.type = ParticleType.CONFETTI;
                particle.alpha = 255;
                
                particles.add(particle);
            }
        }
    }
    
    /**
     * Añade un fuego artificial (explosión de partículas)
     */
    private void addFirework(float x, float y) {
        int particleCount = 30 + random.nextInt(20);
        int color = confettiColors[random.nextInt(confettiColors.length)];
        
        synchronized (particles) {
            for (int i = 0; i < particleCount; i++) {
                double angle = (Math.PI * 2 * i) / particleCount;
                float speed = random.nextFloat() * 8f + 5f;
                
                Particle particle = new Particle();
                particle.x = x;
                particle.y = y;
                particle.vx = (float) (Math.cos(angle) * speed);
                particle.vy = (float) (Math.sin(angle) * speed);
                particle.rotation = 0;
                particle.rotationSpeed = 0;
                particle.size = random.nextFloat() * 6f + 3f;
                particle.color = color;
                particle.type = ParticleType.FIREWORK;
                particle.alpha = 255;
                particle.life = 1.0f;
                particle.gravity = 0.3f;
                
                particles.add(particle);
            }
        }
    }
    
    @Override
    protected void onDraw(Canvas canvas) {
        super.onDraw(canvas);
        
        // Crear copia para evitar ConcurrentModificationException
        // La lista puede ser modificada por el hilo de animación mientras dibujamos
        List<Particle> particlesCopy;
        synchronized (particles) {
            particlesCopy = new ArrayList<>(particles);
        }
        
        // Dibujar todas las partículas
        for (Particle particle : particlesCopy) {
            paint.setColor(particle.color);
            paint.setAlpha(particle.alpha);
            
            if (particle.type == ParticleType.CONFETTI) {
                // Dibujar confetti como rectángulo rotado
                canvas.save();
                canvas.translate(particle.x, particle.y);
                canvas.rotate(particle.rotation);
                canvas.drawRect(-particle.size/2, -particle.size, particle.size/2, particle.size, paint);
                canvas.restore();
            } else {
                // Dibujar fuegos artificiales como círculos
                canvas.drawCircle(particle.x, particle.y, particle.size, paint);
            }
        }
    }
    
    @Override
    public void run() {
        long lastTime = System.currentTimeMillis();
        long fireworkTimer = 0;
        
        while (isAnimating) {
            try {
                long currentTime = System.currentTimeMillis();
                long deltaTime = currentTime - lastTime;
                lastTime = currentTime;
                fireworkTimer += deltaTime;
                
                // Actualizar partículas (sincronizado para evitar conflictos con onDraw)
                List<Particle> toRemove = new ArrayList<>();
                synchronized (particles) {
                    for (Particle particle : particles) {
                        // Aplicar física
                        particle.x += particle.vx;
                        particle.y += particle.vy;
                        particle.rotation += particle.rotationSpeed;
                        
                        if (particle.type == ParticleType.CONFETTI) {
                            // Confetti cae con gravedad y oscila
                            particle.vy += 0.2f;
                            particle.vx += (random.nextFloat() - 0.5f) * 0.2f;
                            
                            // Si sale de la pantalla, marcar para remover
                            if (particle.y > getHeight() + 50) {
                                toRemove.add(particle);
                            }
                        } else {
                            // Fuegos artificiales se desvanecen
                            particle.vy += particle.gravity;
                            particle.life -= 0.02f;
                            particle.alpha = (int) (255 * particle.life);
                            
                            if (particle.life <= 0) {
                                toRemove.add(particle);
                            }
                        }
                    }
                    
                    // Remover partículas muertas
                    particles.removeAll(toRemove);
                }
                
                // Generar fuegos artificiales periódicamente
                if (fireworkTimer > 200) {
                    fireworkTimer = 0;
                    int width = getWidth();
                    int height = getHeight();
                    if (width > 0 && height > 0) {
                        float x = random.nextInt(width);
                        float y = random.nextInt(height / 2);
                        addFirework(x, y);
                    }
                }
                
                // Generar más confetti si hay pocos
                int particleCount;
                synchronized (particles) {
                    particleCount = particles.size();
                }
                if (particleCount < 30) {
                    addConfetti(10);
                }
                
                // Redibujar
                postInvalidate();
                
                // Sleep para ~60 FPS
                Thread.sleep(16);
                
            } catch (InterruptedException e) {
                break;
            } catch (Exception e) {
                android.util.Log.e("BirthdayAnimation", "Error en animación: " + e.getMessage());
            }
        }
    }
    
    /**
     * Clase interna para representar una partícula
     */
    private static class Particle {
        float x, y;           // Posición
        float vx, vy;         // Velocidad
        float rotation;       // Rotación actual
        float rotationSpeed;  // Velocidad de rotación
        float size;           // Tamaño
        int color;            // Color
        int alpha;            // Transparencia
        ParticleType type;    // Tipo de partícula
        float life;           // Vida restante (para fuegos artificiales)
        float gravity;        // Gravedad aplicada
    }
    
    /**
     * Tipos de partículas
     */
    private enum ParticleType {
        CONFETTI,
        FIREWORK
    }
}
