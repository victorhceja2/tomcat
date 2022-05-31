#!/bin/ksh

	exec > /tmp/gen_his_grid.log 2>&1

	echo "Inciando generacion de historia ... "

	nohup /usr/bin/ph/ml/bin/phgenHis_grid.s &
    rm /usr/bin/ph/phgrid_semanal/*
