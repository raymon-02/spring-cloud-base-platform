package io.spring.cloud.example.service.info.rest;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class HelloController {

    @Value("${messages.hello}")
    private String hello;

    @GetMapping("/hello")
    public String getHello() {
        return hello;
    }
}
