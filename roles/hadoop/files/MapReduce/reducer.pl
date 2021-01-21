#!/usr/bin/perl

# $Rev: 266 $ - $Date: 2010-03-21 19:34:01 +0100 (dom 21 de mar de 2010) $

# Copyright 2010 Forondarena.net

#This program is free software: you can redistribute it and/or modify
#it under the terms of the GNU General Public License as published by
#the Free Software Foundation, either version 3 of the License, or
#(at your option) any later version.
#
#This program is distributed in the hope that it will be useful,
#but WITHOUT ANY WARRANTY; without even the implied warranty of
#MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#GNU General Public License for more details.
#
#You should have received a copy of the GNU General Public License
#along with this program.  If not, see <http://www.gnu.org/licenses/>.

use strict;
use warnings;
#use Switch;
use feature qw(switch);
no warnings qw( experimental::smartmatch );
use MIME::Base64;

my $qidanterior = "";
my $qid = "";
my $valor = "";
my @datos = ();
my %mensaje = (qid => "",
				fecha => "",
				servidor => "",
				msgid => "",
				origen => "",
				size => "",
				to => "",
				origto => "",
				rqid => "",
				relay => "",
				status => "",
				cierre => ""
			);

print "server,msgid,input_date,source,to,source_to,from_ip,size,output_date,qid,rqid,status" ."\n";

while (<>) {
	chomp;
    ($qid, $valor) = split /\t/;
    @datos = split(",",$valor);
    $mensaje{fecha} = $datos[1];
	
	if ($qid ne $qidanterior) {
		# tenemos un queueid nuevo
		if ($qidanterior ne "") {
			&mostrar_datos();

			%mensaje = (qid => "",
				fecha => "",
				desdeip => "",
				msgid => "",
				origen => "",
				size => "",
				to => "",
				origto => "",
				rqid => "",
				status => "",
				cierre => ""
			);
		}
		$qidanterior = $qid;
	}

	# seguimos procesando los datos del mismo qid
	$mensaje{qid} = $qid;
	@datos = split(",",$valor);

	# Dependiendo del tipo de linea. En los casos de clientes smtp
	#  $datos[0] = tipo de linea
	#  $datos[1] = fecha
	#  $datos[2] = to
	#  $datos[3] = origto
	#  $datos[4] = relay
	#  $datos[5] = status

	#switch ($datos[0]) {
	given ($datos[0]) {
		#case "Conexion" {
		when ("Conexion") {
			$mensaje{fecha} = $datos[1];
			$mensaje{desdeip} = $datos[2];
		}
		#case "Msgid" {
		when ("Msgid") {
			$mensaje{msgid} = $datos[2];
		}
		#case "Origen" {
		when ("Origen") {
			$mensaje{origen} = $datos[2];
			$mensaje{size} = $datos[3];
		}
		#case "Antispam" {
		when ("Antispam") {
			$mensaje{to} .= $datos[2] . "-separador-";
			$mensaje{origto} .= $datos[3] . "-separador-";
			$mensaje{status} .= $datos[1] . " " .$datos[2] . " " . $datos[3] . " " . $datos[4] . " " . $datos[5] . "-separador-";
			$mensaje{rqid} = $datos[6];
		}
		#case "Smtp" {
		when ("Smtp") {
			$mensaje{to} .= $datos[2] . "-separador-";
			$mensaje{origto} .= $datos[3] . "-separador-";
			$mensaje{status} .= $datos[1] . " " .$datos[2] . " " . $datos[3] . " " . $datos[4] . " " . $datos[5] . "-separador-";
			$mensaje{rqid} = $datos[6];
		}
		#case "Maildrop" {
		when ("Maildrop") {
			$mensaje{to} .= $datos[2] . "-separador-";
			$mensaje{origto} .= $datos[3] . "-separador-";
			$mensaje{status} .= $datos[1] . " " .$datos[2] . " " . $datos[3] . " " . $datos[4] . " " . $datos[5] . "-separador-";
			$mensaje{rqid} = $datos[6];
		}
		#case "Cierre" {
		when ("Cierre") {
			$mensaje{cierre} = $datos[1];
		}
	}
	
}

&mostrar_datos(%mensaje);


sub mostrar_datos {
	my $resto = "";
        my $datosorigen = "";
	my $datoscodificables = "";
	my $fechaentrada = "";
	my $fechasalida = "";

     
        $mensaje{to} =~ s/[\r\n]//g;
	$mensaje{origto} =~ s/[\r\n]//g;
	$mensaje{status} =~ s/[\r\n]//g;

	$mensaje{to} =~ s/-separador-$//g;
	$mensaje{origto} =~ s/-separador-$//g;
	$mensaje{status} =~ s/-separador-$//g;

	$mensaje{to} =~ s/-separador-/;/g;
	$mensaje{origto} =~ s/-separador-/;/g;
	$mensaje{status} =~ s/-separador-/;/g;

	if ( ($mensaje{fecha} ne "") && ($mensaje{cierre} ne "") ) {
		# mensaje completo: Salida estandar
		$fechaentrada = `date -u -d '$mensaje{fecha} 2011' '+%d/%m/%Y %H:%M:%S'`; chomp $fechaentrada;
		$fechasalida = `date -u -d '$mensaje{cierre} 2011' '+%d/%m/%Y %H:%M:%S'`; chomp $fechasalida;
		$datosorigen = $mensaje{msgid} ."," .$fechaentrada ."," . $mensaje{origen} ."," .$mensaje{to} ."," .$mensaje{origto};
		$datoscodificables = $mensaje{desdeip} ."," .$mensaje{size}."," .$fechasalida."," .$mensaje{qid} ."," .$mensaje{rqid} ."," .$mensaje{status};
		$resto = encode_base64($datoscodificables,""); 	

                print "Server," .$datosorigen ."," .$datoscodificables ."\n";

	} else {
		#print "Mensaje: $mensaje{qid}\n";
	}
}

