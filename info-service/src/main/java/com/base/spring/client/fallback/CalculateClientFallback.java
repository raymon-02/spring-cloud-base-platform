package com.base.spring.client.fallback;

import com.base.spring.client.CalculateClient;
import org.springframework.stereotype.Component;

@Component
public class CalculateClientFallback implements CalculateClient {

    public String calculate(int id) {
        return "Wrong id: " + id + "! Feign fallback";
    }

}
