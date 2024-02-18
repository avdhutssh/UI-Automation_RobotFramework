<!--
    #/**
    # * @author Avdhut Shirgaonkar
    # * Email: avdhut.ssh@gmail.com
    # * LinkedIn: https://www.linkedin.com/in/avdhut-shirgaonkar-811243136/
    # */
    #/***************************************************/
-->
---
# 💻# UI-Automation Using RobotFramework

## 📑 Table of Contents
<!-- # - [Video Tutorial](#video-tutorial) -->
- [Introduction](#introduction)
- [Prerequisites](#prerequisites)
- [Getting Started](#getting-started)
- [Running Tests](#running-tests)
- [Project Structure](#project-structure)
- [Reporting](#reporting)
- [Contacts](#contacts)

## 📖 Introduction
This repository contains a Test Automation Framework built using Robot Framework tool and python for automated testing of ECOM Web Application.

## 🛠️ Prerequisites

After installing *pycharm* and *python*, open terminal and install mentioned library to start with robot framework
```pip install robotframework```

## ▶️ Getting Started

1. Clone the repository:

   ```bash
   git clone https://github.com/avdhutssh/UI-Automation_RobotFramework.git
   ```

2. Navigate to the project directory:

   ```bash
   cd UI-Automation_RobotFramework
   ```


## 🚀 Running Tests

  ```bash
  robot -d Result '.\Test Cases\001_EcomApp.robot'
  ```

## 📁 Project Structure

This project is following Page Object Model (**POM**) Pattern and using  __Hybrid Framework__ (keyword driven and Data Driven).

Data driven testing is done by using CSV and Robot Framework BuiltIn Template methods

One standalone test script is also created for all test cases flows.

Refer Test script under Test cases folder for execution.


## 📊 Reporting

To generate a report in Robot Framework, you need to run your test suite using the robot command. By default, this command will create three files in the output directory: output. xml, log. html, and report.

![alt text](image.png)

## 📧 Contacts

- [![Email](https://img.shields.io/badge/Email-avdhut.ssh@gmail.com-green)](mailto:avdhut.ssh@gmail.com)
- [![LinkedIn](https://img.shields.io/badge/LinkedIn-Profile-blue)](https://www.linkedin.com/in/avdhut-shirgaonkar-811243136/)

Feel free to reach out if you have any questions, or suggestions

Happy Learning!!!