program main
    implicit none
    CHARACTER(LEN=255) :: HOME
    CHARACTER(LEN=32767) :: ARG
    CHARACTER(LEN=:), ALLOCATABLE :: TRIMV,TRIMA
    INTEGER :: ARGCOUNT,INDEX,FSTAT,CSTAT
    LOGICAL :: EXIST,SILENT = .false.
    ARGCOUNT = COMMAND_ARGUMENT_COUNT()
    IF (ARGCOUNT .eq. 0) CALL EXIT(1)
    CALL GET_ENVIRONMENT_VARIABLE('HOME',HOME)
    IF (HOME .eq. '') CALL EXIT(2)
    DO INDEX=1,ARGCOUNT
        CALL GET_COMMAND_ARGUMENT(INDEX,ARG)
        TRIMA = TRIM(ARG)
        IF (TRIMA .eq. '-h' .or. &
            TRIMA .eq. '--help' .or. &
            TRIMA .eq. '-H' .or. &
            TRIMA .eq. '--HELP') THEN
            WRITE(*,'(A)') '', &
                ' USAGE: bashconf [OPTIONS]... [FILENAMES]...', &
                ' Create .bash_ configuration files if they do ', &
                ' not exist in the user'//"'"//'s directory.', &
                '', &
                ' OPTIONS: all optional', &
                '      -h, --help    this help screen.', &
                '      -s, --silent  run non-verbosely.', &
                '', &
                ' FILENAMES: not optional.', &
                '', &
                ' EXIT CODES:', &
                '     0              no errors.', &
                '     1              no file names passed.', &
                '     2              no $HOME path for user.', &
                ''
            CALL EXIT(0)
        END IF
        IF (TRIMA .eq. '-s' .or. &
            TRIMA .eq. '--silent' .or. &
            TRIMA .eq. '-S' .or. &
            TRIMA .eq. '--SILENT') THEN
                SILENT = .true.
        END IF
    END DO
    IF (SILENT .eqv. .false.) WRITE(*,'(A)') ''
    DO INDEX=1,ARGCOUNT
        CALL GET_COMMAND_ARGUMENT(INDEX,ARG)
        TRIMA = TRIM(ARG)
        IF (TRIMA .ne. '-s' .and. &
            TRIMA .ne. '--silent' .and. &
            TRIMA .ne. '-S' .and. &
            TRIMA .ne. '--SILENT') THEN
            TRIMV = TRIM(HOME)//'/.bash_'//TRIM(ARG)
            INQUIRE(FILE=TRIMV,EXIST=EXIST)
            IF (EXIST) THEN
                IF (SILENT .eqv. .false.) WRITE(*,'(A)') TRIMV//' already exists and was not created.'
            ELSE
                IF (SILENT .eqv. .false.) WRITE(*,'(A)') 'Attempting to create file: '//TRIMV
                OPEN(INDEX,FILE=TRIMV,STATUS="new",ACTION="write",IOSTAT=FSTAT)
                IF (FSTAT .eq. 0) THEN
                    CLOSE(INDEX,STATUS='KEEP',IOSTAT=CSTAT)
                    IF (CSTAT .eq. 0) THEN
                        IF (SILENT .eqv. .false.) WRITE(*,'(A)') TRIMV//' created.'
                    ELSE
                        IF (SILENT .eqv. .false.) WRITE(*,'(A)') 'Could not create '//TRIMV//'.'
                    END IF
                ELSE
                    IF (SILENT .eqv. .false.) WRITE(*,'(A)') 'Could not create '//TRIMV//'.'
                END IF
            END IF
        END IF
    END DO
    IF (SILENT .eqv. .false.) WRITE(*,'(A)') ''
end program main