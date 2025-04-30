package com.example.footbal_fields.models;

import lombok.Data;

import java.util.List;
@Data
public class Field {
    private int id;
    private String address;
    private double x;
    private double y;
    private List<Service> services;
    private String name;
    private String is_paid;
    private String paymentComment;
    private int seats;
    private String lighting;
    private String disability;
    private String phone;
    private String email;

    public void setEmail(String email) {
        this.email = email;
    }

    public String getEmail() {
        return email;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getIs_paid() {
        return is_paid;
    }

    public void setIs_paid(String is_paid) {
        this.is_paid = is_paid;
    }

    public int getSeats() {
        return seats;
    }

    public void setSeats(int seats) {
        this.seats = seats;
    }

    public String getDisability() {
        return disability;
    }

    public void setDisability(String disability) {
        this.disability = disability;
    }

    public String getPaymentComment() {
        return paymentComment;
    }

    public void setPaymentComment(String paymentComment) {
        this.paymentComment = paymentComment;
    }

    public String getLighting() {
        return lighting;
    }

    public void setLighting(String lighting) {
        this.lighting = lighting;
    }

    public void setName(String name){this.name=name;}
    public String getName(){return name;}

    public int getId() {
        return id;
    }

    public double getX() {
        return x;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public void setX(double x) {
        this.x = x;
    }

    public double getY() {
        return y;
    }

    public void setY(double y) {
        this.y = y;
    }


    public List<Service> getServices() {
        return services;
    }

    public void setServices(List<Service> services) {
        this.services = services;
    }
}
