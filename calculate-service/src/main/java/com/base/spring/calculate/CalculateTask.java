package com.base.spring.calculate;

import com.netflix.hystrix.contrib.javanica.annotation.HystrixCommand;
import com.netflix.hystrix.contrib.javanica.annotation.HystrixProperty;
import org.springframework.stereotype.Component;

import java.util.Random;

@Component
public class CalculateTask {

    private static final Random random = new Random();

    @HystrixCommand(
            fallbackMethod = "calculateInfoFallback",
            commandProperties = {
                    @HystrixProperty(
                            name = "execution.isolation.thread.timeoutInMilliseconds",
                            value = "2000"
                    )
            }
    )
    public String calculateInfo() throws InterruptedException {
        int randomInt = random.nextInt(3);
        if (randomInt != 2) {
            return "No timeout!";
        }

        Thread.sleep(3000L);
        return "Timeout! But original method";
    }

    public String calculateInfoFallback() {
        return "Timeout! Fallback method";
    }

}
