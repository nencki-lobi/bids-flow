#!/usr/bin/python
# -*- coding: utf-8 -*-
#3. PLOTS SUMMARY DATA FROM FBIRN SCRIPTS
import os
import sys
import re
import csv
from xml.dom import minidom
from datetime import datetime
from dateutil.relativedelta import relativedelta
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as pyplot

if len(sys.argv)==1 or len(sys.argv)>4:
	print('Command: qaplotter.py directory output (months). Program will search and load QA XML files. Longitudinal plots will be saved in specified dir.')
	sys.exit()

if len(sys.argv)==4:
	today=datetime.today()
	begin=today-relativedelta(months=int(sys.argv[3]))

#DIRECTORY SEARCH
directory = str(sys.argv[1])
pattern = 'summaryQA.xml$' 
fileList = []
for root, subFolders, files in os.walk(directory):  
	for file in files:
		if re.search(pattern,file):
			#if re.search("12ch",root):
			fileList.append(os.path.join(root,file))
			#end
items = len(fileList)
print('qaplotter will analyze ' + directory + ' containing ' + str(items) + ' xml(s).')

#XML PARSING
data_all=[]
for file in fileList:
	xml_struct=minidom.parse(file)
	summary = xml_struct.getElementsByTagName("measurementGroup")[0] #get first mG - summary
	data = {}
	for subelement in summary.getElementsByTagName("observation"):
		for attrName, attrValue in subelement.attributes.items():
			#print "attribute %s = %s" % (attrName, attrValue)
			if attrValue=='float':
				lastName = subelement.getAttribute('name')
				#print "%s = %s" % (lastName, subelement.firstChild.nodeValue)
				data[lastName]=float(subelement.firstChild.nodeValue)
			elif attrValue=='scandate':
				dt = datetime.strptime(subelement.firstChild.nodeValue,"%Y-%m-%d")
				#print dt
				data['date']=dt
	data_all.append(data)
data_all=sorted(data_all, key=lambda k: k['date'])

#PLOTS
x = [d['date'] for d in data_all]
for key in data_all[0]:
	if key!='date':
		y = [d[key] for d in data_all]
		pyplot.plot(x,y,'-o')
		pyplot.title(key)
		if len(sys.argv)==4:
			pyplot.xlim(begin,today)
		#pyplot.show()
		pyplot.xticks(rotation=70)
		pyplot.savefig(sys.argv[2]+'/'+key+'.png', bbox_inches='tight')
		pyplot.close()

fieldnames = ['meanFWHMX', 'meanFWHMY' , 'meanFWHMZ']
pyplot.figure()
for fn in fieldnames:
	y = [d[fn] for d in data_all]	
	pyplot.plot(x, y, '-o', label=fn[-1:])
pyplot.legend(loc='upper left')
pyplot.title('FWHM')
pyplot.xticks(rotation=70)
pyplot.savefig(sys.argv[2]+'/FWHM.png', bbox_inches='tight')
pyplot.close()

#with open('data.csv', 'wb') as csvfile:
#	fieldnames = ['meanFWHMX', 'meanFWHMY' , 'meanFWHMZ']
#    	writer = csv.DictWriter(csvfile, fieldnames=fieldnames, extrasaction='ignore')
#    	writer.writeheader()
#    	writer.writerows(data_all)




