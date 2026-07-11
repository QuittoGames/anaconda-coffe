from dataclasses import  dataclass,field

@dataclass
class Profile:
    profile:str # Just for referece in JSON

    packages:dict = field(default_factory=dict) # DNF packages
    langs:dict = field(default_factory=dict) # Special Types of DNF packages , representend languages of code

    desktop:str
    shell:str
    repositorys:list = field(default_factory=list)
    distros:list = field(default_factory=list)
