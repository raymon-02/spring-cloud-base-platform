package com.base.spring.rest;

import com.base.spring.service.CalculateService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class CalculateController {

    @Autowired
    private CalculateService calculateService;

    @GetMapping("/calculate/{id}")
    public String calculate(@PathVariable int id) {
        return calculateService.calculate(id);
    }

}
