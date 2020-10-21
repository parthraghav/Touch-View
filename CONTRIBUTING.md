sudo pip3 install -r requirements.txt 
pip3 freeze > requirements.txt
source venv/bin/activate
python -m ipykernel install --user --name=venv