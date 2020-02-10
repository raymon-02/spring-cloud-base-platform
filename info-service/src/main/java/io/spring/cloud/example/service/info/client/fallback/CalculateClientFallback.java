package io.spring.cloud.example.service.info.client.fallback;

import io.spring.cloud.example.service.info.client.CalculateClient;
import org.springframework.stereotype.Component;

import java.util.Map;

@Component
public class CalculateClientFallback implements CalculateClient {

    public String calculate(int id, Map<String, Integer> params) {
        return "Exception: id=" + id + " Feign fallback!";
    }

}
