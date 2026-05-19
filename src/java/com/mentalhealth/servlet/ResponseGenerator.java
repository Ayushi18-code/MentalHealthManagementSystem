package com.mentalhealth.chatbot;

import java.util.HashMap;
import java.util.Map;
import java.util.regex.Pattern;
//import java.util.regex.Matcher;

public class ResponseGenerator {
    private static final Map<String, String[]> POSITIVE_PATTERNS = new HashMap<>();
    private static final Map<String, String[]> NEGATIVE_PATTERNS = new HashMap<>();
    private static final Map<String, String[]> SAD_PATTERNS = new HashMap<>();
    
    static {
        // "Train" with mental health empathetic responses (from datasets like Kaggle mental health convos) [web:24]
        NEGATIVE_PATTERNS.put("sad", new String[]{"I'm sorry you're feeling this way. It's okay to feel sad sometimes.", "That sounds really tough. Want to talk more about it?"});
        NEGATIVE_PATTERNS.put("anxious", new String[]{"Anxiety can be overwhelming. Try deep breathing: in for 4, hold 4, out 4.", "You're not alone. Many people feel anxious—let's work through this."});
        SAD_PATTERNS.put("depress", new String[]{"Depression is serious. I'm here to listen without judgment.", "It's brave to reach out. Have you considered professional support?"});
        POSITIVE_PATTERNS.put("happy", new String[]{"That's wonderful! Keep nurturing that positivity.", "Great to hear! What made you feel that way?"});
    }
    
    public static String generateEmpatheticResponse(String input) {
        String lowerInput = input.toLowerCase();
        
        // Simple sentiment: keyword count for negative bias [web:25]
        if (hasPattern(lowerInput, NEGATIVE_PATTERNS.keySet()) || hasPattern(lowerInput, SAD_PATTERNS.keySet())) {
            return getRandomResponse(lowerInput, NEGATIVE_PATTERNS, SAD_PATTERNS);
        } else if (hasPattern(lowerInput, POSITIVE_PATTERNS.keySet())) {
            return getRandomResponse(lowerInput, POSITIVE_PATTERNS);
        }
        return "I understand. Tell me more—I'm here to support you.";
    }
    
    private static boolean hasPattern(String input, Iterable<String> patterns) {
        for (String pat : patterns) {
            if (Pattern.compile(pat).matcher(input).find()) return true;
        }
        return false;
    }
    
    private static String getRandomResponse(String input, Map<String, String[]>... maps) {
        for (Map<String, String[]> map : maps) {
            for (Map.Entry<String, String[]> entry : map.entrySet()) {
                if (Pattern.compile(entry.getKey()).matcher(input).find()) {
                    String[] responses = entry.getValue();
                    return responses[(int)(Math.random() * responses.length)];
                }
            }
        }
        return "I'm listening carefully.";
    }
}