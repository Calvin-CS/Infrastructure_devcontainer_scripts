This container is just responsible for creating a requirements.txt file, based off of requests
from various professors. I need a "frozen" versions requirements.txt file to maintain consistency
across lab machines and the coder instance.

How to: 
 ADD packages to the creator -- modify packages-list and then run the build process
 BUILD and Create the VENV and requirements.txt file from the packages-list set of Python packages -- run ./build.sh
 SEE the built and versioned requirements.txt file -- run ./show-requirements.sh

Copy the output of ./show-requirements.sh to ../scripts/requirements.txt and push to Github to rebuild the images