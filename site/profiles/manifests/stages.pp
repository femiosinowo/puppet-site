class profiles::stages () {
  # defining stages here
  #
  stage { 'repo': }

  stage { 'dns': }

  stage { 'pre': }

  stage { 'post': }

  stage { 'testing': }

}