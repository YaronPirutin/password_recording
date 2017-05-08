import os
import commands
import sys

curr_path = "/home/yaron/git/password_recording"
if sys.argv[1]=="1": #enroll option
    aud_path = sys.argv[2] #path of the audio
    name = sys.argv[3] #name of the person
    os.chdir(curr_path + "/speaker-recognition/src/people")
    dir_list = os.listdir(curr_path + "/speaker-recognition/src/people")
    os.system("mkdir " + name)
    os.system("cp -b " + aud_path + " " + curr_path + "/speaker-recognition/src/people/" + name + "/")
    os.chdir(curr_path + "/speaker-recognition/src")
    dir_str = ""
    for folder in dir_list:
        dir_str += ("./people/" + folder + " ")

    print "python2 speaker-recognition.py -t enroll -i " + "\"" +dir_str+ "\"" " -m model.out"
    os.system("python2 speaker-recognition.py -t enroll -i " + "\"" +dir_str+ "\"" " -m model.out")
else:
    aud_path = sys.argv[1]#path of the audio
    os.chdir(curr_path + "/speaker-recognition/src")
    status , output = commands.getstatusoutput("python2 speaker-recognition.py -t predict -i " + aud_path + " -m model.out")
    print output
