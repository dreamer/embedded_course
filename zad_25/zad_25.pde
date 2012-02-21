// vim: noai:ts=4:sw=4

/*
- 5V  <-> -
- GND <-> +

- J41, J42  (speaker)
- 8 <-> F39 (speaker)
*/

#include <SPI.h>
#include <Ethernet.h>
#include <EthernetUdp.h>

#define VERBOSE

#define NOTE_C4 (262)
#define SPEAKER_PIN (8)
#define DELAY (30)
#define BUFFER_SIZE (256)

#define IS_EMPTY(str) (!str[0])
#define REQUEST_STARTS_WITH(str) (0 == strncmp(buffer, str, strlen(str)))

enum Resource { INDEX, PLAY_PAUSE, NOT_FOUND, POST, NONE };

//byte mac[] = { 0x48, 0x5D, 0x60, 0xB5, 0x73, 0xC5 }; // dreamer_
byte mac[] = { 0x48, 0x5D, 0x60, 0xB5, 0x73, 0xAA }; // random
//IPAddress ip(192,168,2,84);
//byte subnet[] = { 255, 255, 252, 0 };
//byte gateway[] = { 0, 0, 0, 0 };

char buffer[BUFFER_SIZE] = { '\0' };
bool is_playing = false;
int resource = NONE;
int empty_lines = 0;
bool save_post_data = false;

EthernetServer server(80);

void signal_on()
{
	tone(SPEAKER_PIN, NOTE_C4, 4);
}

void signal_off()
{
	noTone(SPEAKER_PIN);
}

int get_resource()
{
	if (REQUEST_STARTS_WITH("GET / ")) return INDEX;
	if (REQUEST_STARTS_WITH("GET /pp/ ")) return PLAY_PAUSE;
	if (REQUEST_STARTS_WITH("POST /upload/ ")) return POST;
	return NOT_FOUND;
}

void println(const char* str)
{
#ifdef VERBOSE
	Serial.println(str);
#endif
}

void send_index(EthernetClient &client)
{
	client.println("HTTP/1.1 200 OK");
	client.println("Content-Type: text/html");
	client.print("\n"
			"<!doctype html>\n"
			"<html>\n"
			"<title>Obnoxious beeper</title>\n"
			"<body>\n"
			"<form>\n"
			"<input type=file id=upload name=files>\n"
			//"<input type=submit>\n"
			"</form>\n"
			"<a href=/pp/>"
			);
	client.print(is_playing ? "Pause" : "Play");
	client.println("</a>");
	client.println(
			"<p id=log></p>\n"
			"<script>\n"
			"function uploadFiles(url, files) {\n"
			"  var formData = new FormData();\n"
			"  for (var i = 0, file; file = files[i]; ++i) {\n"
			"    formData.append(file.name, file);\n"
			"  }\n"
			"  var xhr = new XMLHttpRequest();\n"
			"  xhr.open('POST', url, true);\n"
			"  xhr.onload = function(e){};\n"
			"  xhr.send(formData);\n"
			"  document.getElementById('log').innerHTML += 'uploading file...<br>';\n"
			"}\n"
			"document.querySelector('input[type=\"file\"]').onchange = function(e) {\n"
			"  uploadFiles('/upload/', this.files);\n"
			"};\n"
			"</script>\n"
			);
}

void setup()
{
	Serial.begin(9600);

	println("Configure Ethernet using DHCP...");
	//if (Ethernet.begin(mac, ip, gateway, subnet) == 0) {
	if (Ethernet.begin(mac) == 0) {
		println("Failed to configure Ethernet.");
		return;
	}
	Serial.println(Ethernet.localIP());

	server.begin();
	println("Obnoxious beeper started.\n");
}

void loop()
{
	// loop server:

	EthernetClient client = server.available();
	if (client) {
		resource = NONE;

		while (client.connected()) {
			if (client.available()) {
				memset(buffer, '\0', BUFFER_SIZE);
				client.readBytesUntil('\n', buffer, BUFFER_SIZE-1);
				println(buffer);

				if (save_post_data) {
					if (strcmp(buffer, "\r") == 0) {
						save_post_data = false;
						// TODO: act with data!
						break;
					}
					Serial.print('[');
					Serial.print(buffer);
					Serial.println(']');
				}

				if (resource == NONE) {
					resource = get_resource();
					empty_lines = 0;
					save_post_data = false;
				}

				if (resource == POST) {
					if (strcmp(buffer, "\r") == 0)
						empty_lines++;
					if (empty_lines == 2)
						save_post_data = true;
				} else {
					if (strcmp(buffer, "\r") == 0) {
						println(":: sending response\n");

						switch (resource) {
							case PLAY_PAUSE: is_playing = !is_playing;
							case INDEX:	send_index(client); break;
							case POST:
										client.println("HTTP/1.1 200 OK");
										break;
							case NOT_FOUND:
							default:
										client.println("HTTP/1.1 404 Not Found");
						};
						break;
					}
				}
			}
		}

		delay(1);
		client.stop();
	}

	// loop sound:

	if (is_playing)
		signal_on();
	else
		signal_off();

	delay(1);
}
