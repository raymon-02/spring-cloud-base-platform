package com.base.spring.service;

import com.base.spring.calculate.CalculateTask;
import lombok.SneakyThrows;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class CalculateService {

    @Autowired
    private CalculateTask calculateTask;

    @SneakyThrows
    public String calculate() {
        return calculateTask.calculateInfo();
    }

}
