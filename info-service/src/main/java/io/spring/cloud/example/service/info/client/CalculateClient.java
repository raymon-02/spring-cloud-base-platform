package io.spring.cloud.example.service.info.client;

import io.spring.cloud.example.service.info.client.fallback.CalculateClientFallback;
import org.springframework.cloud.netflix.feign.FeignClient;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.Map;

@FeignClient(
        name = "calculate-server",
        fallback = CalculateClientFallback.class
)
public interface CalculateClient {

    @RequestMapping(value = "/calculate/{id}")
    String calculate(
            @PathVariable("id") int id,
            @RequestParam Map<String, Integer> params
    );
}
