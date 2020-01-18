import requests
from dotenv import load_dotenv
load_dotenv()
import os
ACCESS_KEY = os.getenv("ACCESS_KEY")
SECRET_KEY = os.getenv("SECRET_KEY")





from flask import Flask

app = Flask(__name__)

@app.route("/")
def home():
    return "Hello, World!"

@app.route("/SampleApiCall/<foodId>")
def salvador(foodId):

    #classification recieved from model*****this must be given/taken from the ML model
    label  = "grilled%20cheese"
    # label = foodId

    #url used to get common and branded food items json file
    url = "https://trackapi.nutritionix.com/v2/search/instant?query="+str(label)

    #url used to get the nutrional info of given food item
    API_ENDPOINT = "https://trackapi.nutritionix.com/v2/natural/nutrients"

    #headers used for .get and .post requests. do not change.
    headers = {'content-type': 'application/json', 'x-app-id' : ACCESS_KEY, 'x-app-key' : SECRET_KEY, 'x-remote-user-id':'0'}

    r = requests.get(url = url, headers = headers)
    data = r.json()
    # return data
    name = data['common'][0]['food_name']


    params = {'query':str(name)}
    # sending post request and saving response as response object
    r = requests.post(url = API_ENDPOINT, json = params, headers = headers)
    data = r.json()
    # return data

    servings = 1

    x = {
      "Calories": str(float(servings)*data['foods'][0]['nf_calories'])+"kCal",
      "Fat": str(float(servings)*data['foods'][0]['nf_total_fat'])+"g",
      "Cholestrol": str(float(servings)*data['foods'][0]['nf_cholesterol'])+"mg",
      "Sodium": str(float(servings)*data['foods'][0]['nf_sodium'])+"mg",
      "Carbohydrates": str(float(servings)*data['foods'][0]['nf_total_carbohydrate'])+"g",
      "Fiber": str(float(servings)*data['foods'][0]['nf_dietary_fiber'])+"g",
      "Sugar": str(float(servings)*data['foods'][0]['nf_sugars'])+"g",
      "Protein": str(float(servings)*data['foods'][0]['nf_protein'])+"g",
      "Potassium": str(float(servings)*data['foods'][0]['nf_potassium'])+"mg",
      "Sugars": str(float(servings)*data['foods'][0]['nf_sugars'])+"g"
    }

#     x={
# 'userId': 1,
# 'id': 1,
# 'title': "This should probably work",
# 'body': "This should work"
# }

    return x

if __name__ == "__main__":
    app.run(debug=True)







#classification recieved from model*****this must be given/taken from the ML model
label  = "grilled%20cheese"

#url used to get common and branded food items json file
url = "https://trackapi.nutritionix.com/v2/search/instant?query="+str(label)

#url used to get the nutrional info of given food item
API_ENDPOINT = "https://trackapi.nutritionix.com/v2/natural/nutrients"

#headers used for .get and .post requests. do not change.
headers = {'content-type': 'application/json', 'x-app-id' : ACCESS_KEY, 'x-app-key' : SECRET_KEY, 'x-remote-user-id':'0'}



#returns name of food item from the API
def getSearchQuery():
    r = requests.get(url = url, headers = headers)
    data = r.json()
    name = data['common'][0]['food_name']
    return name




def getMacros(name):
    params = {'query':str(name)}
    # sending post request and saving response as response object
    r = requests.post(url = API_ENDPOINT, json = params, headers = headers)
    data = r.json()



    print(str(data['foods'][0]['serving_unit']))
    servings = getServings(str(data['foods'][0]['serving_unit']))

    #get all macros
    macros = ""
    macros += "Calories: "+str(float(servings)*data['foods'][0]['nf_calories'])+"kCal"+"\n"
    macros += "Fat: "+str(float(servings)*data['foods'][0]['nf_total_fat'])+"g"+"\n"
    macros += "Cholestrol: "+str(float(servings)*data['foods'][0]['nf_cholesterol'])+"mg"+"\n"
    macros += "Sodium: "+str(float(servings)*data['foods'][0]['nf_sodium'])+"mg"+"\n"
    macros += "Carbohydrates: "+str(float(servings)*data['foods'][0]['nf_total_carbohydrate'])+"g"+"\n"
    macros += "Fiber: "+str(float(servings)*data['foods'][0]['nf_dietary_fiber'])+"g"+"\n"
    macros += "Sugar: "+str(float(servings)*data['foods'][0]['nf_sugars'])+"g"+"\n"
    macros += "Protein: "+str(float(servings)*data['foods'][0]['nf_protein'])+"g"+"\n"
    macros += "Potassium: "+str(float(servings)*data['foods'][0]['nf_potassium'])+"mg"+"\n"
    macros += "Sugars: "+str(float(servings)*data['foods'][0]['nf_sugars'])+"g"+"\n"

    print(macros)
    return macros


def getServings(unit):
    servings = input("Enter servings ("+str(unit)+"): ")
    servings = 1
    return servings


# getMacros(getSearchQuery())
