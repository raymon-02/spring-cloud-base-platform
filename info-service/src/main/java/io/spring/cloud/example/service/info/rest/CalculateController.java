package io.spring.cloud.example.service.info.rest;

import io.spring.cloud.example.service.info.service.CalculateService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import javax.validation.constraints.Max;
import javax.validation.constraints.Min;

@RestController
@Validated
public class CalculateController {

    @Autowired
    private CalculateService calculateService;

    @GetMapping("/calculate/{id}")
    public String calculate(
            @PathVariable int id,
            @RequestParam(required = false, defaultValue = "0") @Min(0) int timeout,
            @RequestParam(required = false, defaultValue = "0") @Min(0) @Max(100) int error

    ) {
        return calculateService.calculate(id, timeout, error);
    }

}
