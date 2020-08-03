#
# Geometric Correction Execution file
#
# Methuen Jelani Bell-Isaac
# Bard College Class of 2019

'''
This Python script executes image warping using 
affine transformations to remove distortion
from a projection.
'''

import cv2
import numpy as np
import json

image = cv2.imread('mario.png',-1)

# resolution of display that is being projected
dsize = (4800, 2700)

triangles = open('triangles.json')
json_file = open('full_mesh2.json') # destination nodes
original_json = open('test3.json') # source nodes

data = json.load(json_file)
org = json.load(original_json)
tri = json.load(triangles)

'''
Get the source nodes
return a tuple of x and y value pairs
'''
def getOriginal(pid):
    triangle = tri[str(pid)]
    point_1 = (org[str(triangle["v1"])]["x"] , org[str(triangle["v1"])]["y"])
    point_2 = (org[str(triangle["v2"])]["x"] , org[str(triangle["v2"])]["y"])
    point_3 = (org[str(triangle["v3"])]["x"] , org[str(triangle["v3"])]["y"])

    return point_1, point_2, point_3

'''
Get the destination nodes
return a tuple of x and y value pairs
'''

def getTriangle(pid):
    
    triangle = tri[str(pid)]
    point_1 = (data[str(triangle["v1"])]["x"], data[str(triangle["v1"])]["y"])
    point_2 = (data[str(triangle["v2"])]["x"], data[str(triangle["v2"])]["y"])
    point_3 = (data[str(triangle["v3"])]["x"], data[str(triangle["v3"])]["y"])

    return point_1, point_2, point_3

'''
Apply masking
return an ROI that has isolated the desired triangle
'''
def getMaskedImage(pid):
    mask = np.zeros(image.shape, dtype=np.uint8)
    p1, p2, p3 = getOriginal(pid)
    roi = np.array([[p1, p2, p3]], dtype=np.int32)
    # fill the ROI so it doesn't get wiped out when the mask is applied
    channel_count = 4  # i.e. 3 or 4 depending on your image
    ignore_mask_color = (255,)*channel_count
    cv2.fillPoly(mask, roi, ignore_mask_color)
    
    # apply the mask
    masked_image = cv2.bitwise_and(image, mask)
    
    return masked_image

'''
Get and apply the affine transformation
Return the warped ROI

'''
def getWarpedImage(pid):
    s1, s2, s3 = getOriginal(pid)
    d1, d2, d3 = getTriangle(pid)
    masked_image = getMaskedImage(pid)
    src = np.float32([[s1[0] ,s1[1]], [s2[0] ,s2[1]], [s3[0],s3[1]]])
    dest = np.float32([[d1[0],d1[1]], [d2[0],d2[1]], [d3[0],d3[1]]])
    affine_transform = cv2.getAffineTransform(src,dest)
    warped_image = cv2.warpAffine(masked_image, affine_transform, dsize)
    
    return warped_image

final_warp = getWarpedImage(0) # Initialize the final image with the triangle at "0".

counter = 0

'''
Get the warped ROI for each triangle in the mesh and
Combine the warped images to construct the complete warped image
'''
for i in tri:

   
    img = getWarpedImage(i)
   
    final_warp = cv2.bitwise_or(final_warp, img)
    print("Triangles left: " + str((len(tri) - counter)))
    counter += 1
    
print("Image Warp Successful!")
cv2.imwrite('image4.png', final_warp)  