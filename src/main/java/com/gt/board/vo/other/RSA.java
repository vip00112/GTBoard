package com.gt.board.vo.other;

import java.security.PrivateKey;

public class RSA {
    private PrivateKey privateKey;
    private String modulus;
    private String exponent;

    public RSA() {
    }

    public RSA(PrivateKey privateKey, String modulus, String exponent) {
        this.privateKey = privateKey;
        this.modulus = modulus;
        this.exponent = exponent;
    }

    public PrivateKey getPrivateKey() {
        return privateKey;
    }

    public void setPrivateKey(PrivateKey privateKey) {
        this.privateKey = privateKey;
    }

    public String getModulus() {
        return modulus;
    }

    public void setModulus(String modulus) {
        this.modulus = modulus;
    }

    public String getExponent() {
        return exponent;
    }

    public void setExponent(String exponent) {
        this.exponent = exponent;
    }

}
