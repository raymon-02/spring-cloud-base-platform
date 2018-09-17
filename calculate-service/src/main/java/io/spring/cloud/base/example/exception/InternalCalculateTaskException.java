package io.spring.cloud.base.example.exception;

public class InternalCalculateTaskException extends RuntimeException {

    private static final long serialVersionUID = 7018170798984042662L;

    public InternalCalculateTaskException(String message) {
        super(message);
    }
}
