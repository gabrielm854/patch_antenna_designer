#!/usr/bin/env python3
import math
import os
import shutil

terminal_width = os.get_terminal_size().columns
os.system('clear')

light_speed = float(299792458)

print("Please, enter the following information: \n")
substrate_h = float(input("Substrate's thickness (mm): "))/1000
substrate_epsilon = float(input("Substrate's dielectric constant: "))
frequency = float(input("Frequency: "))*10**9

os.system('clear')

methodOption = int(input("Please select the antenna calculation method you would like to use:\n (1) Transmission Line Method\n (2) Cavities Method\n Method: "))

## Method Selection
os.system('clear')
if methodOption == 1:
    ### Transmission Line Method
    print("-- TRANSMISSION LINE METHOD --\n\n".center(terminal_width))
    patch_w = ((light_speed/(2*frequency))*math.sqrt(2/(substrate_epsilon + 1)))
    if (patch_w/substrate_h) < 1:
        epsilon_eff = ((substrate_epsilon + 1)/2) + ((substrate_epsilon - 1)/2)*(1+12*(substrate_h/patch_w))**(-0.5) + 0.04*(1-(patch_w/substrate_h))**2
    else:
        epsilon_eff = ((substrate_epsilon + 1)/2) + ((substrate_epsilon - 1)/2)*(1+12*(substrate_h/patch_w))**(-0.5)
    L_eff = (light_speed)/(2*frequency*math.sqrt(epsilon_eff))
    deltaL = 0.412*substrate_h*(((epsilon_eff + 0.3)*((patch_w/substrate_h) + 0.264))/((epsilon_eff - 0.258)*((patch_w/substrate_h) + 0.8)))
    patch_l = (L_eff - deltaL)*1000
    patch_w = patch_w*1000
elif methodOption == 2:
    ### Cavities Method
    print("-- CAVITIES METHOD --")
else:
    print("ERROR: Please select a valid option.")


print("Patch Length: %.2f [mm]\nPatch Width: %.2f [mm]\n\n\n" %(patch_l,patch_w))
print("Copyright Gabriel Alexis Muniz Negron\n\n\n\n\n\n\n\n\n\n".center(terminal_width))
