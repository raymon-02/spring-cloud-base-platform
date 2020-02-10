package io.spring.cloud.example.service.info.service;

import io.spring.cloud.example.service.info.client.CalculateClient;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.Map;

@Service
public class CalculateService {

    private static final String TIMEOUT = "timeout";
    private static final String ERROR = "error";

    @Autowired
    private CalculateClient client;

    public String calculate(int id, int timeout, int error) {
        Map<String, Integer> params = new HashMap<>();
        params.put(TIMEOUT, timeout);
        params.put(ERROR, error);

        return client.calculate(id, params);
    }

}
