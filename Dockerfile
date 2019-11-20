FROM jupyter/scipy-notebook:17aba6048f44
RUN pip install nltk yellowbrick lxml
RUN python -c "import nltk; nltk.download('stopwords')"