import os
import shutil


takeFile = 0  # Kaçıncı dosyayı almak istiyorsun - 1
destination = "./Results"  # Sonuç dosyası ./Dosya Adı

if (os.path.isdir((destination)) == False):
    os.makedirs((destination))
    print("folder created '" + destination + "'")

for folder in os.walk("./"):
    (folderName, subFolders, files) = folder
    if (folderName == "./" or folderName == destination):
        continue
    if (len(files) >= takeFile + 1):
        firstFilePath = folderName + "/" + files[takeFile]
        shutil.copy2(firstFilePath, destination+"/"+folderName.replace(".hdf5","")+".tsv")
    else:
        print("folder '" + folderName +
              "' does not contain " + str(takeFile) + " files.")
