package io.spring.cloud.base.example.service;

import io.spring.cloud.base.example.calculate.CalculateTask;
import lombok.SneakyThrows;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class CalculateService {

    @Autowired
    private CalculateTask calculateTask;

    @SneakyThrows
    public String calculate(int timeout, int error) {
        return calculateTask.calculateInfo(timeout, error);
    }

}
