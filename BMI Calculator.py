#!/usr/bin/env python
# coding: utf-8

# In[1]:


weight = int(input("Enter your weight in pounds: "))

height = int(input("Enter your height in inches: "))

BMI = ( weight * 703) / ( height * height)

print(BMI)

if BMI>0:
    if(BMI<18.5):
        print("underweight")
    elif(BMI<=24.9):
        print("normal weight")
    elif(BMI<=29.9):
        print("overweight")
    elif(BMI<=34.9):
        print("obese")
    elif(BMI<=39.9):
        print("severly obese")
    else:
        print("morbidly obese")
else :
    print("Unvalide input")


# In[ ]:




