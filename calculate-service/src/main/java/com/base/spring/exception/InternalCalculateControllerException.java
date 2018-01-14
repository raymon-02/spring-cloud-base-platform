package com.base.spring.exception;

import org.springframework.web.bind.annotation.ResponseStatus;

import static org.springframework.http.HttpStatus.NOT_IMPLEMENTED;

@ResponseStatus(NOT_IMPLEMENTED)
public class InternalCalculateControllerException extends RuntimeException {

    private static final long serialVersionUID = 2413405587364494783L;

    public InternalCalculateControllerException(String message) {
        super(message);
    }
}
