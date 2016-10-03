class roles::jenkins_master(){
	include profiles::base
	include profiles::jenkins_base
	include profiles::jenkins_master
}
