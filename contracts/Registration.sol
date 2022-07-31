// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.0 <0.9.0;
contract Registration{
  address YOK;
  address TOBB;
  address CB;

  enum Title { DR, AS_PROF, PROF,MD }

   struct University
    {
      bool status;
      bytes32 name;
      bytes32 country;
    }
  struct Academician
    {
      bool status;
      bytes32 university;
      bytes32 department;
      Title title; 
      bytes32 name;
      bytes32 surname;
    }
   struct  Student
    {
      bool status;
      bytes32 university;
      bytes32 department;
      bytes32 name;
      bytes32 surname;
    }
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
      mapping(address=>University)  universities;
      bytes32 department;
      bytes32 name;
      bytes32 surname;
    }

    mapping(address=>University) public universities;
    mapping(address=>Academician) public academicians;
    mapping(address=>Company) public  companies;
    mapping(address=>Course) public  courses;
    mapping(address=>PublicInstitution) public publicInstitutions;
    mapping(address=>NGO) public ngos;
    mapping(address=>Student) public students;

    event UniversityRegisteredLog(address _universityAddress,bytes32  _name, bytes32 _country);
    event StudentRegisteredLog(address _studentAddress,bytes32  _name,bytes32  _surname,bytes32  _department,bytes32  _university);
    event AcademicianRegisteredLog(address _academicianAddress,bytes32  _name,bytes32  _surname,bytes32  _department,bytes32  _university,Title _title);
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
      require(universities[msg.sender].status,
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
      require(universities[msg.sender].status||companies[msg.sender].status||publicInstitutions[msg.sender].status,
      "Bu islemi sadece Kurs yapabilir."
      );
      _;
    } 
      modifier onlyOwner {
      require(msg.sender == address(this),
      "Bu islemi sadece kontrat sahibi yapabilir");
      _;
   }
     function isStudent(address _address) public view returns(bool){
        return students[_address].status;
    }
      function isAcademician(address _address) public view returns(bool){
        return academicians[_address].status;
    }
      function isCompany(address _address) public view returns(bool){
        return companies[_address].status;
    }
      function isPublicInstitution(address _address) public view returns(bool){
        return publicInstitutions[_address].status;
    }
      function isUniversity(address _address) public view returns(bool){
        return universities[_address].status;
    }
      function isCourse(address _address) public view returns(bool){
        return courses[_address].status;
    }
       function isNGO(address _address) public view returns(bool){
        return ngos[_address].status;
    }
 function registerUniversity(address _universityAddress,bytes32 _name, bytes32 _country) 
  public onlyYOK{
        require(!universities[_universityAddress].status,
            "University exists already"
            );
            
        universities[_universityAddress].status=true;
        universities[_universityAddress].name=_name;
        universities[_universityAddress].country=_country;

        emit UniversityRegisteredLog( _universityAddress, _name, _country);
       
    }
  function registerStudent(address _studentAddress, bytes32 _name, bytes32 _surname, bytes32 _department, bytes32 _university) 
  public onlyUniversity{
        require(!students[_studentAddress].status,
            "Student exists already"
            );
            
        students[_studentAddress].status=true;
        students[_studentAddress].name=_name;
        students[_studentAddress].surname=_surname;
        students[_studentAddress].university=_university;
        students[_studentAddress].department=_department;

        emit StudentRegisteredLog( _studentAddress,  _name,  _surname,  _department,  _university);
    }

     function registerAcademician(address _academicianAddress, bytes32 _name, bytes32 _surname, bytes32 _department, bytes32 _university, Title _title) 
  public onlyUniversity{
        require(!academicians[_academicianAddress].status,
            "Academician exists already"
            );
            
        academicians[_academicianAddress].status=true;
        academicians[_academicianAddress].title=_title;
        academicians[_academicianAddress].name=_name;
        academicians[_academicianAddress].surname=_surname;
        academicians[_academicianAddress].university=_university;
        academicians[_academicianAddress].department=_department;

        emit AcademicianRegisteredLog( _academicianAddress,  _name,  _surname,  _department,  _university, _title);
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

