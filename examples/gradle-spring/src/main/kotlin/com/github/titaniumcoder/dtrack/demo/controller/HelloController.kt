package com.github.titaniumcoder.dtrack.demo.controller

import org.springframework.stereotype.Controller
import org.springframework.ui.Model
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.ResponseBody

@Controller
class HelloController {

    @GetMapping("/")
    fun hello(model: Model): String {
        model.addAttribute("message", "Hello World!")
        model.addAttribute("subtitle", "Welcome to our beautiful Spring Boot application")
        return "hello"
    }

    @GetMapping("/api/hello")
    @ResponseBody
    fun helloJson(): Map<String, String> {
        return mapOf("hello" to "world")
    }
}