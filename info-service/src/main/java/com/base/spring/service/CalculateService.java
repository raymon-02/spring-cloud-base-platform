package com.base.spring.service;

import com.base.spring.client.CalculateClient;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class CalculateService {

    @Autowired
    private CalculateClient client;

    public String calculate(int id) {
        return client.calculate(id);
    }

}
