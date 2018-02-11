package com.base.spring.calculate;

import com.base.spring.exception.InternalCalculateTaskException;
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
    public String calculateInfo(int timeout, int error) throws InterruptedException {
        Thread.sleep(timeout);

        if (throwException(error)) {
            throw new InternalCalculateTaskException("Calculate exception");
        }

        return "Ok!";
    }

    public String calculateInfoFallback(int timeout, int error) {
        return "Hystrix fallback method!";
    }

    private static boolean throwException(int rate) {
        int randomInt = random.nextInt(100);
        return randomInt < rate;
    }

}
