import os
import commands

x = raw_input("enter 1 to enroll enter 2 to predict")
status , curr_path = commands.getstatusoutput('echo $PWD')
if x=="1":
    aud_path = raw_input("please enter the path of your audio : ")
    name = raw_input("please enter your name : ")
    os.chdir(curr_path + "/speaker-recognition/src/people")
    dir_list = os.listdir(curr_path + "/speaker-recognition/src/people")
    if (name in dir_list) == False :
        os.system("mkdir " + name)
    os.system("cp -b " + aud_path + " " + curr_path + "/speaker-recognition/src/people/" + name + "/")
    os.chdir(curr_path + "/speaker-recognition/src")
    dir_str = ""
    for folder in dir_list:
        dir_str += ("./people/" + folder + " ")

    print "python2 speaker-recognition.py -t enroll -i " + "\"" +dir_str+ "\"" " -m model.out"
    os.system("python2 speaker-recognition.py -t enroll -i " + "\"" +dir_str+ "\"" " -m model.out")
else:
    aud_path = raw_input("please enter the path of your audio")
    os.chdir(curr_path + "/speaker-recognition/src")
    status , output = commands.getstatusoutput("python2 speaker-recognition.py -t predict -i " + aud_path + " -m model.out")
print output
