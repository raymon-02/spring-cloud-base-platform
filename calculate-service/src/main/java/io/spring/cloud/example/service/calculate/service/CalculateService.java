package io.spring.cloud.example.service.calculate.service;

import io.spring.cloud.example.service.calculate.task.CalculateTask;
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
