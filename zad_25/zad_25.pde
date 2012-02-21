// vim: noai:ts=4:sw=4

/*
- 5V  <-> -
- GND <-> +

- J41, J42  (speaker)
- 8 <-> F39 (speaker)
*/

#include <SPI.h>
#include <Ethernet.h>
//#include <EthernetUdp.h>

#define VERBOSE

#define SPEAKER_PIN (8)
#define DELAY (30)
#define BUFFER_SIZE (128)
#define MELODY_BUFFER_SIZE (128)

#define IS_EMPTY(str) (!str[0])
#define IS_RETC(str) (str[0] == '\r' && str[1] == '\0')
//#define REQUEST_STARTS_WITH(str) (0 == strncmp(buffer, str, strlen(str)))

enum Resource { INDEX, PLAY_PAUSE, NOT_FOUND, POST, NONE };

//byte mac[] = { 0x48, 0x5D, 0x60, 0xB5, 0x73, 0xC5 }; // dreamer_
byte mac[] = { 0x48, 0x5D, 0x60, 0xB5, 0x73, 0xAA }; // random
//IPAddress ip(192,168,2,84);
//byte subnet[] = { 255, 255, 252, 0 };
//byte gateway[] = { 0, 0, 0, 0 };

int melody_notes[MELODY_BUFFER_SIZE] = { '\0' };
int melody_notes_durations[MELODY_BUFFER_SIZE] = { '\0' };
int notes = 0;
bool is_playing = false;

char buffer[BUFFER_SIZE] = { '\0' };
int resource = NONE;
int empty_lines = 0;
bool save_post_data = false;
int current_note = 0;

EthernetServer server(80);

void parse_post()
{
	int note, duration;
	sscanf(buffer, "%d:%d", &note, &duration);
	melody_notes[notes] = note;
	melody_notes_durations[notes] = duration;
}

int get_resource()
{
	//if (REQUEST_STARTS_WITH("GET / ")) return INDEX;
	//if (REQUEST_STARTS_WITH("GET /pp/ ")) return PLAY_PAUSE;
	//if (REQUEST_STARTS_WITH("POST /upload/ ")) return POST;

	if (buffer[0] == 'G' && buffer[5] == ' ') return INDEX;
	if (buffer[0] == 'G' && buffer[5] == 'p') return PLAY_PAUSE;
	if (buffer[0] == 'P') return POST;

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
			"var formData = new FormData();\n"
			"for (var i = 0, file; file = files[i]; ++i) {\n"
			"formData.append(file.name, file);\n"
			"}\n"
			"var xhr = new XMLHttpRequest();\n"
			"xhr.open('POST', url, true);\n"
			"xhr.onload = function(e){};\n"
			"xhr.send(formData);\n"
			//"document.getElementById('log').innerHTML += 'uploading file...<br>';\n"
			"}\n"
			"document.querySelector('input[type=\"file\"]').onchange = function(e) {\n"
			"uploadFiles('/upload/', this.files);\n"
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
		save_post_data = false;

		while (client.connected()) {
			if (client.available()) {
				memset(buffer, '\0', BUFFER_SIZE);
				client.readBytesUntil('\n', buffer, BUFFER_SIZE-1);
				println(buffer);

				if (resource == NONE) {
					resource = get_resource();
					empty_lines = 0;

					// start loading new melody
					if (resource == POST)
						current_note = notes = 0;
				}

				if (save_post_data) {
					//if (strcmp(buffer, "\r") == 0) {
					if (IS_RETC(buffer)) {
						save_post_data = false;
						break;
					}
					parse_post();
					notes++;
					if (notes >= MELODY_BUFFER_SIZE)
						notes = MELODY_BUFFER_SIZE;
				}

				if (resource == POST) {
					//if (strcmp(buffer, "\r") == 0)
					if (IS_RETC(buffer))
						empty_lines++;
					if (empty_lines == 2)
						save_post_data = true;

				} else {

					//if (strcmp(buffer, "\r") == 0) {
					if (IS_RETC(buffer)) {
						println(":: sending response\n");
						switch (resource) {
							case PLAY_PAUSE:
								is_playing = !is_playing;
							case INDEX:
								send_index(client);
								break;
							//case POST:
							//			client.println("HTTP/1.1 200 OK");
							//			break;
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
	if (is_playing) {
		int i = current_note;
		int n = melody_notes[i];
		int d = 1000 / melody_notes_durations[i];
		tone(SPEAKER_PIN, n, d);
		delay(d*2);
		noTone(SPEAKER_PIN);
		current_note = (current_note + 1) % notes;
	}
	else
		noTone(SPEAKER_PIN);

	delay(1);
}
