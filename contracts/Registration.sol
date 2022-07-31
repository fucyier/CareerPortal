// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.0 <0.9.0;

import "./EgitimBilgileri.sol";

contract Registration{
  address YOK;
  address TOBB;
  address CB;
    EgitimBilgileri egitimBilgileri;


   struct Company
    {
      bool status;
      bytes32 country;
      uint identityNumber;
      bytes32 name;
    }
     struct PublicInstitution
    {
      bool status;
      bytes32 name;
      bytes32 country;
    }
      struct NGO
    {
      bool status;
      bytes32 name;
      bytes32 country;
    }
    struct Course
    {
      bool status;
      bytes32 name;
      bytes32 country;
    }
    
    struct  Person
    {
      bool status;
      EgitimBilgileri.EducationInfo[] educations;
    }
        



 
 
    mapping(address=>Company) public  companies;
    mapping(address=>Course) public  courses;
    mapping(address=>PublicInstitution) public publicInstitutions;
    mapping(address=>NGO) public ngos;
    mapping(address=>Person) public people;


    event PersonRegisteredLog(address _personAddress);
 
    event CompanyRegisteredLog(address _companyAddress,bytes32  _name, uint _identityNumber,bytes32  _country);
    event PublicInstitutionRegisteredLog(address _institutionAddress,bytes32  _name,bytes32  _country);
    event NGORegisteredLog(address _ngoAddress,bytes32  _name,bytes32  _country);
    event CourseRegisteredLog(address _courseAddress,bytes32  _name,bytes32  _country);

    constructor (address _yok, address _tobb, address _cb){
        YOK=_yok;
        TOBB=_tobb;
        CB=_cb;
    }
    
    modifier onlyYOK{
      require(msg.sender == YOK,
      "Sadece YOK bu islemi yapabilir."
      );
      _;
    }    
    
    modifier onlyTOBB{
      require(msg.sender == TOBB,
      "Sadece TOBB bu islemi yapabilir."
      );
      _;
    }    
    modifier onlyCB{
      require(msg.sender == CB,
      "Sadece CB bu islemi yapabilir."
      );
      _;
    }    
    modifier onlyUniversity{
      require(egitimBilgileri.isUniversity(msg.sender),
      "Sadece Universite bu islemi yapabilir."
      );
      _;
    } 
  modifier onlyCourse{
      require(courses[msg.sender].status,
      "Bu islemi sadece Kurs yapabilir."
      );
      _;
    } 
     modifier Only_Uni_Comp_Publ{
      require(egitimBilgileri.isUniversity(msg.sender)||companies[msg.sender].status||publicInstitutions[msg.sender].status,
      "Bu islemi sadece Kurs yapabilir."
      );
      _;
    } 
      modifier onlyOwner {
      require(msg.sender == address(this),
      "Bu islemi sadece kontrat sahibi yapabilir");
      _;
   }
     function isPerson(address _address) public view returns(bool){
        return people[_address].status;
    }

      function isCompany(address _address) public view returns(bool){
        return companies[_address].status;
    }
      function isPublicInstitution(address _address) public view returns(bool){
        return publicInstitutions[_address].status;
    }

      function isCourse(address _address) public view returns(bool){
        return courses[_address].status;
    }
       function isNGO(address _address) public view returns(bool){
        return ngos[_address].status;
    }
 function registerUniversity(address _universityAddress,bytes32 _name, uint8 _country) 
  public onlyYOK{
        require(!egitimBilgileri.isUniversity(_universityAddress),
            "University exists already"
            );
        egitimBilgileri.addUniversite(_universityAddress,_name,_country);

    }
  function registerStudent(address _studentAddress,EgitimBilgileri.EducationInfo memory _egitimBilgileri) 
  public onlyUniversity{
        require(!people[_studentAddress].status,
            "Student exists already"
            );
            
        people[_studentAddress].status=true;
        people[_studentAddress].educations.push(_egitimBilgileri) ;

        emit PersonRegisteredLog( _studentAddress);
    }

     function registerAcademician(address _academicianAddress,address _universityAddress, bytes32 _name, bytes32 _surname,uint16 _bolum, EgitimBilgileri.Unvan _unvan) 
  public onlyUniversity{
        require(!egitimBilgileri.isAcademician(_academicianAddress),
            "Academician exists already"
            );
            
         egitimBilgileri.addAcademician( _academicianAddress, _universityAddress,  _name,  _surname, _bolum,  _unvan);

      
    }
  function registerCompany(address _companyAddress,bytes32 _name, uint _identityNumber,bytes32 _country) 
  public onlyTOBB{
        require(!companies[_companyAddress].status,
            "Company exists already"
            );
            
        companies[_companyAddress].status=true;
        companies[_companyAddress].name=_name;
        companies[_companyAddress].country=_country;
        companies[_companyAddress].identityNumber=_identityNumber;

        emit CompanyRegisteredLog( _companyAddress,  _name,  _identityNumber,  _country);
       
    }
     function registerPublicInstitution(address _institutionAddress,bytes32 _name, bytes32 _country) 
     public onlyCB{
        require(!publicInstitutions[_institutionAddress].status,
            "Public Institution exists already"
            );
            
        publicInstitutions[_institutionAddress].status=true;
        publicInstitutions[_institutionAddress].name=_name;
        publicInstitutions[_institutionAddress].country=_country;

        emit PublicInstitutionRegisteredLog( _institutionAddress,  _name, _country);
       
    }
     function registerCourse(address _courseAddress,bytes32 _name, bytes32 _country) 
     public Only_Uni_Comp_Publ{
        require(!courses[_courseAddress].status,
            "Public Institution exists already"
            );
            
        courses[_courseAddress].status=true;
        courses[_courseAddress].name=_name;
        courses[_courseAddress].country=_country;
        
        emit CourseRegisteredLog( _courseAddress,  _name, _country);
       
    }
     function registerNGO(address _ngoAddress,bytes32 _name, bytes32 _country) 
     public onlyOwner{
        require(!ngos[_ngoAddress].status,
            "Public Institution exists already"
            );
            
        courses[_ngoAddress].status=true;
        courses[_ngoAddress].name=_name;
        courses[_ngoAddress].country=_country;
        
        emit NGORegisteredLog( _ngoAddress,  _name, _country);
       
    }
}

