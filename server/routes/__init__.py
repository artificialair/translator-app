from flask import Blueprint
routes = Blueprint('routes', __name__)

from .index import *
from .test_post import *
from .translate import *